using Data.Context;
using Domain.Model;
using Infrastructure.Exceptions;
using Infrastructure.Mediator;
using MediatR;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Security
{
    public class ActorFetchHandler<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
    {
        private readonly IHttpContextAccessor contextAccessor;
        private readonly CoffeeDb db;

        public ActorFetchHandler(IHttpContextAccessor contextAccessor, CoffeeDb db)
        {
            this.contextAccessor = contextAccessor;
            this.db = db;
        }

        public async Task<TResponse> Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate<TResponse> next)
        {
            if (request is IActorAwareRequest<TResponse> actorAwareRequest)
            {
                // If it's not null, keep the current value
                if (actorAwareRequest.Actor is null)
                {
                    var idClaim = contextAccessor.HttpContext.User.Claims.FirstOrDefault(x => x.Type == nameof(User.Id));
                    if (idClaim is null)
                    {
                        throw new BadRequestException($"This token doesn't the {nameof(User.Id)} claim");
                    }
                    var id = Guid.Parse(idClaim.Value);
                    var user = await db.Users
                        //.Include(x => x.Administrator)
                        .FirstOrDefaultAsync(x => x.Id == id);
                    if (user is null || user.DeletedAt.HasValue)
                    {
                        throw new NotFoundException($"{nameof(User)} not found");
                    }
                    actorAwareRequest.Actor = user;
                }
            }
            var response = await next();
            return response;
        }
    }
}
