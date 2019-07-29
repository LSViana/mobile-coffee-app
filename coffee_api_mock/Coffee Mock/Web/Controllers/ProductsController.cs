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
            var products = await db.Products
                .Where(x => x.Stores.Any(y => y.StoreId == storeId))
                .ToArrayAsync();
            return Ok(products.Select(x => new
            {
                x.Id,
                x.Name,
                x.ImageUrl,
                x.Description,
                x.CategoryId,
                x.Price,
                Favorite = user == null ? false : x.Users.Any(y => y.UserId == user.Id),
                PriceUnit = "R$",
            }));
        }

        [Authorize]
        public async Task<IActionResult> SetFavorite([FromRoute] Guid id)
        {
            var user = await this.GetUserAuthenticated(db);
            if(user is null)
            {
                return Unauthorized();
            }
            // Set favorite value
        }
    }
}