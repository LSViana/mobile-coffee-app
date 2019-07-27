using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
            var user = await db.Users.FindAsync(id);
            if(user != null)
            {
                return Ok(new
                {
                    user.Id,
                    user.Name,
                    user.Email,
                    user.DeliveryAddress,
                });
            }
            else
            {
                return NotFound();
            }
        }
    }
}