using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : Controller
    {
        private readonly IMediator mediator;

        public UsersController(IMediator mediator)
        {
            this.mediator = mediator;
        }

        [HttpPost]
        [AllowAnonymous]
        public async Task<IActionResult> Create([FromBody] Infrastructure.Features.Users.Create.Command command)
            => CreatedAtAction(nameof(Read), new { (await mediator.Send(command)).Id }, null);

        [HttpGet("{id}")]
        [AllowAnonymous]
        public async Task<IActionResult> Read([FromRoute] Guid id)
            => Ok(await mediator.Send(new Infrastructure.Features.Users.Read.Query { Id = id }));
    }
}
