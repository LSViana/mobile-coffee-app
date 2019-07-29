using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;
using Web.Extensions;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private readonly Db db;

        public ProductsController(Db db)
        {
            this.db = db;
        }

        [HttpGet("bystore/{storeId}")]
        public async Task<IActionResult> ListByStore([FromRoute] Guid storeId)
        {
            var user = await this.GetUserAuthenticated(db);
            var userId = user?.Id ?? Guid.Empty;
            var products = db.Products
                .Where(x => x.Stores.Any(y => y.StoreId == storeId))
                .Select(x => new
                {
                    x.Id,
                    x.Name,
                    x.ImageUrl,
                    x.Description,
                    x.CategoryId,
                    x.Price,
                    Favorite = x.Users.Any(y => y.UserId == userId),
                    PriceUnit = "R$",
                });
            return Ok(products);
        }

        [Authorize]
        [HttpPatch("togglefavorite/{id}")]
        public async Task<IActionResult> SetFavorite([FromRoute] Guid id)
        {
            var user = await this.GetUserAuthenticated(db);
            if (user is null)
            {
                return Unauthorized();
            }
            // Set favorite value
            var product = await db.Products
                .Include(x => x.Users)
                .FirstOrDefaultAsync(x => x.Id == id);
            if (product is null)
                return NotFound();
            var userFavorite = product.Users?.FirstOrDefault(x => x.UserId == user.Id);
            if (userFavorite is null)
            {
                // Add as favorite if it's not yet
                userFavorite = new Domain.UserHasFavorite
                {
                    Product = product,
                    User = user
                };
                await db.UserHasFavorites.AddAsync(userFavorite);
            }
            else
            {
                // Remove from favorites if it's there
                db.UserHasFavorites.Remove(userFavorite);
            }
            // Save changes to database
            await db.SaveChangesAsync();
            return Ok();
        }
    }
}
