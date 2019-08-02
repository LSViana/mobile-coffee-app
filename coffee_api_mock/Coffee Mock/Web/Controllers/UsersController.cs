using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Web.Data;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly Db db;

        public UsersController(Db db)
        {
            this.db = db;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Read([FromRoute] Guid id)
        {
            var user = await db.Users
                .Select(x => new
                {
                    x.Id,
                    x.Name,
                    x.Email,
                    x.DeliveryAddress,
                    UserHasStore = x.Stores.Any(),
                })
                .FirstOrDefaultAsync(x => x.Id == id);
            //
            if (user != null)
            {
                return Ok(user);
            }
            return NotFound();
        }
    }
}
