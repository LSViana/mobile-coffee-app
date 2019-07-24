using Data.Context;
using Domain.Model;
using Domain.Rules;
using FluentValidation;
using Infrastructure.Exceptions;
using Infrastructure.Security;
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
    public class Create
    {
        public class Command : IRequest<Result>
        {
            public string Name { get; set; }
            public string Email { get; set; }
            public string Password { get; set; }
        }

        public class CommandValidator : AbstractValidator<Command>
        {
            public CommandValidator()
            {
                RuleFor(x => x.Name)
                    .NotEmpty()
                    .Length(UserRules.MinimumLengthName, UserRules.MaximumLengthName);
                RuleFor(x => x.Email)
                    .NotEmpty()
                    .EmailAddress()
                    .Length(UserRules.MinimumLengthEmail, UserRules.MaximumLengthEmail);
                RuleFor(x => x.Password)
                    .NotEmpty()
                    .Length(UserRules.MinimumLengthPassword, UserRules.MinimumLengthPassword);
            }
        }

        public class Result
        {
            public Guid Id { get; set; }
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
                // Verify if there's any user with the same e-mail
                var userSameEmail = await db.Users
                    .Where(x => x.DeletedAt == null)
                    .FirstOrDefaultAsync(x => x.Email.Equals(request.Email, StringComparison.InvariantCultureIgnoreCase));
                if (userSameEmail != null)
                {
                    throw new ConflictException(new ErrorInformation { Message = "User with same e-mail already exists" });
                }
                // Create password information
                var salt = Guid.NewGuid().ToByteArray();
                var hash = CoffeeHasher.HashWithSalt(request.Password, salt);
                // Create the user
                var user = new User
                {
                    Id = Guid.NewGuid(),
                    Name = request.Name,
                    Email = request.Email,
                    PasswordSalt = salt,
                    PasswordHash = hash,
                    // Metadata
                    CreatedAt = DateTime.Now,
                };
                // Save the user to database
                await db.Users.AddAsync(user);
                await db.SaveChangesAsync();
                // Return result
                return new Result { Id = user.Id };
            }
        }

    }

}
