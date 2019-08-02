using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Web.Data;
using Web.Domain;
using Web.Extensions;
using Web.Transfer.Request;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RequestsController : ControllerBase
    {
        private readonly Db db;
        private readonly IConfiguration configuration;

        public RequestsController(Db db, IConfiguration configuration)
        {
            this.db = db;
            this.configuration = configuration;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateRequest createRequest)
        {
            var user = await this.GetUserAuthenticated(db);
            if (user is null)
                return Forbid();
            //
            var invalid = false;
            invalid |= string.IsNullOrWhiteSpace(createRequest.DeliveryAddress);
            invalid |= createRequest.DeliveryDate != null && createRequest.DeliveryDate <= DateTime.Now;
            invalid |= createRequest.Items.Any(x => x.ProductId == Guid.Empty || x.Amount < 1);
            if(invalid)
            {
                return BadRequest();
            }
            //
            var store = await db.Stores
                .Include(x => x.Users)
                .FirstOrDefaultAsync(x => x.Id == createRequest.StoreId);
            var products = await db.Products.ToArrayAsync();
            // TODO Validate if that product is in that store
            //
            var request = new Domain.Request
            {
                CreatedAt = DateTime.Now,
                User = user,
                Store = store,
                DeliveryAddress = createRequest.DeliveryAddress,
                DeliveryDate = createRequest.DeliveryDate,
                Status = Domain.RequestStatus.Sent,
                Items = createRequest.Items.Select(x =>
                {
                    var product = products.First(y => y.Id == x.ProductId);
                    return new Domain.RequestItem
                    {
                        Amount = x.Amount,
                        Product = product,
                        Price = product.Price,
                    };
                })
                .ToArray(),
            };
            //
            await db.Requests.AddAsync(request);
            await db.SaveChangesAsync();
            //
            var storeUserIds = store.Users.Select(x => x.UserId);
            var tasks = new List<Task>();
            foreach (var storeUserId in storeUserIds)
            {
                tasks.Add(this.NotifyUser(db, configuration, storeUserId, $"Request from {user.Name} worth R$ {request.Items.Sum(x => x.Price * x.Amount)}", "Access Orders Page for further details"));
            }
            await Task.WhenAll(tasks);
            //
            return Ok();
        }

        [Authorize]
        [HttpGet("mine")]
        public async Task<IActionResult> Mine()
        {
            var user = await this.GetUserAuthenticated(db);
            if (user is null)
                return Forbid();
            //
            var requestsQuery = db.Requests
                .Where(x => x.UserId == user.Id)
                .OrderByDescending(x => x.CreatedAt);
            var requestsOutput = FormatRequests(requestsQuery);
            //
            return Ok(requestsOutput);
        }

        [Authorize]
        [HttpGet("bystore/{storeId}")]
        public async Task<IActionResult> ListByStore([FromRoute] Guid storeId)
        {
            var user = await this.GetUserAuthenticated(db);
            if (user is null)
            {
                return Forbid();
            }
            //
            var store = await db.Stores
                .Include(x => x.Users)
                .FirstOrDefaultAsync(x => x.Id == storeId);
            if (store is null)
            {
                return NotFound();
            }
            //
            if(store.Users.All(x => x.UserId != user.Id))
            {
                return Forbid();
            }
            //
            var requestsQuery = db.Requests
                .Where(x => x.StoreId == store.Id)
                .OrderByDescending(x => x.CreatedAt);
            var requestsOutput = FormatRequests(requestsQuery);
            //
            return Ok(requestsOutput);
        }

        [HttpPatch("{id}/status/{status}")]
        public async Task<IActionResult> SetStatus([FromRoute] RequestStatus status, [FromRoute] Guid id)
        {
            var request = await db.Requests.FindAsync(id);
            //
            if (request is null)
                return NotFound();
            //
            if(Enum.IsDefined(typeof(RequestStatus), status))
            {
                request.Status = status;
                db.Requests.Update(request);
                await db.SaveChangesAsync();
                //
                var requestCustomerId = request.UserId;
                await this.NotifyUser(db, configuration, requestCustomerId, $"Your request created at {request.CreatedAt.ToShortTimeString()} is now: {request.Status}", "Access the Orders page for further details");
                //
                return Ok();
            }
            else
            {
                return BadRequest();
            }
        }

        public IQueryable FormatRequests(IQueryable<Request> requests)
            => requests.Select(x => new
            {
                x.Id,
                x.CreatedAt,
                x.DeliveryAddress,
                x.DeliveryDate,
                x.Status,
                Store = new
                {
                    x.Store.Id,
                    x.Store.Name,
                    x.Store.ImageUrl
                },
                User = new
                {
                    x.User.Id,
                    x.User.Name,
                    x.User.Email
                },
                Items = x.Items.Select(y => new
                {
                    y.Id,
                    y.Amount,
                    y.Price,
                    Product = new
                    {
                        y.Product.Id,
                        y.Product.Name,
                        y.Product.ImageUrl,
                        PriceUnit = "R$",
                    },
                }),
            });
    }
}
