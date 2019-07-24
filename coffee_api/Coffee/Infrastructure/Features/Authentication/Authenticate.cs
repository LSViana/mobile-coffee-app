using Data.Context;
using Domain.Rules;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;
using Infrastructure.Exceptions;

namespace Infrastructure.Features.Authentication
{
    public class Authenticate
    {
        public class Command : IRequest<Result>
        {
            public string Email { get; set; }
            public string Password { get; set; }
        }

        public class CommandValidator : AbstractValidator<Command>
        {
            public CommandValidator()
            {
                RuleFor(x => x.Email).NotEmpty().EmailAddress();
                RuleFor(x => x.Password).NotEmpty().MinimumLength(UserRules.MinimumLengthPassword);
            }
        }

        public class Result
        {
            public Guid Id { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public DateTime ExpiresAt { get; set; }
            public string Token { get; set; }
        }

        public class RequestHandler : IRequestHandler<Command, Result>
        {
            private readonly CoffeeDb db;
            private readonly IMediator mediator;

            public RequestHandler(CoffeeDb db, IMediator mediator)
            {
                this.db = db;
                this.mediator = mediator;
            }

            public async Task<Result> Handle(Command request, CancellationToken cancellationToken)
            {
                var user = await db.Users
                    .Where(x => x.DeletedAt == null)
                    .FirstOrDefaultAsync(x => x.Email.Equals(request.Email, StringComparison.InvariantCultureIgnoreCase));
                if(user is null)
                {
                    throw new NotFoundException(new ErrorInformation { Message = "User with this e-mail not found" });
                }
                //
                var jwt = await mediator.Send(new GenerateJwt.Command { User = user });
                return new Result
                {
                    Id = user.Id,
                    Name = user.Name,
                    Email = user.Email,
                    ExpiresAt = jwt.ExpiresAt,
                    Token = jwt.Token
                };
            }
        }

    }
}
