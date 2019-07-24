using Data.Context;
using Domain.Rules;
using FluentValidation;
using MediatR;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Requests.Authentication
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

            public RequestHandler(CoffeeDb db)
            {
                this.db = db;
            }

            public async Task<Result> Handle(Command request, CancellationToken cancellationToken)
            {
                // TODO Remove the mock
                var user = await db.Users.FirstOrDefaultAsync();
                return new Result
                {
                    Id = user.Id,
                    Name = user.Name,
                    Email = user.Email,
                    ExpiresAt = DateTime.Now.AddHours(1),
                    Token = "{token}"
                };
            }
        }

    }
}
