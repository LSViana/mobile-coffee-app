using Data.Context;
using Domain.Model;
using FluentValidation;
using Infrastructure.Exceptions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Features.Users
{
    public class Read
    {
        public class Query : IRequest<Result>
        {
            public Guid Id { get; set; }
        }

        public class CommandValidator : AbstractValidator<Query>
        {
            public CommandValidator()
            {
                RuleFor(x => x.Id).NotEmpty();
            }
        }

        public class Result
        {
            public Guid Id { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string DeliveryAddress { get; set; }
        }

        public class RequestHandler : IRequestHandler<Query, Result>
        {
            private readonly CoffeeDb db;

            public RequestHandler(CoffeeDb db)
            {
                this.db = db;
            }

            public async Task<Result> Handle(Query request, CancellationToken cancellationToken)
            {
                var user = await db.Users
                    .Where(x => x.DeletedAt == null)
                    .FirstOrDefaultAsync(x => x.Id == request.Id);
                if(user is null)
                {
                    throw new NotFoundException(new ErrorInformation { Message = $"{nameof(User)} not found" });
                }
                return new Result
                {
                    Id= user.Id,
                    Name= user.Name,
                    Email= user.Email,
                    DeliveryAddress = user.DeliveryAddress,
                };
            }
        }

    }

}
