using MediatR;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : Controller
    {
        private readonly IMediator mediator;

        public ProductsController(IMediator mediator)
        {
            this.mediator = mediator;
        }

        [HttpGet("bystore/{storeId}")]
        public async Task<IActionResult> ListByStore([FromRoute] Infrastructure.Features.Products.ListByStore.Query request)
            => Ok(await mediator.Send(request));
    }
}
