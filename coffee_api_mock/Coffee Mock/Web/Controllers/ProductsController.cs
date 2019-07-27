using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Web.Data;

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
                PriceUnit = "R$",
            }));
        }
    }
}