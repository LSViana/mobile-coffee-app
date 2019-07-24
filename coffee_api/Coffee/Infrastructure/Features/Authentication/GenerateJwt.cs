using Data.Context;
using Domain.Model;
using FluentValidation;
using Infrastructure.ConfigurationModels;
using Infrastructure.Security;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Infrastructure.Features.Authentication
{
    public class GenerateJwt
    {
        public class Command : IRequest<Result>
        {
            public User User { get; set; }
        }

        public class CommandValidator : AbstractValidator<Command>
        {
            public CommandValidator()
            {
                RuleFor(x => x.User).NotEmpty();
            }
        }

        public class Result
        {
            public string Token { get; set; }
            public DateTime ExpiresAt { get; set; }
        }

        public class RequestHandler : IRequestHandler<Command, Result>
        {
            private readonly CoffeeDb db;
            private readonly IConfiguration configuration;

            public RequestHandler(CoffeeDb db, IConfiguration configuration)
            {
                this.db = db;
                this.configuration = configuration;
            }

            public async Task<Result> Handle(Command request, CancellationToken cancellationToken)
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var jwtOptions = new JwtConfigurationData();
                configuration.Bind("jwt", jwtOptions);
                // Token configurations
                var tokenLifetime = TimeSpan.FromDays(jwtOptions.LifetimeDays);
                var now = DateTime.Now;
                var jwtToken = tokenHandler.CreateJwtSecurityToken(new SecurityTokenDescriptor()
                {
                    Audience = jwtOptions.Audience,
                    Issuer = jwtOptions.Issuer,
                    Expires = now + tokenLifetime,
                    IssuedAt = now,
                    NotBefore = now,
                    Subject = await GetClaimsFromPermissions(request.User.Id),
                    SigningCredentials =
                        new SigningCredentials(
                            JwtSecurity.GetSecurityKey(jwtOptions.SecretKey, jwtOptions.SecurityPhrase),
                            SecurityAlgorithms.HmacSha256
                        ),
                });
                return new Result
                {
                    Token = tokenHandler.WriteToken(jwtToken),
                    ExpiresAt = jwtToken.ValidTo,
                };
            }

            private async Task<ClaimsIdentity> GetClaimsFromPermissions(Guid id)
            {
                var user = await db.Users
                    // The following includes bring the user roles
                    //.Include(x => x.Administrator)
                    .FirstOrDefaultAsync(x => x.Id == id);
                // The claims to be returned
                var claims = new List<Claim>();
                // Verify which claims to addcan
                //if (user.Administrator != null && !user.Administrator.IsDeleted())
                //    claims.Add(new Claim(nameof(Administrator), AuthorizationPolicies.True));
                //
                claims.Add(new Claim(nameof(User.Id), id.ToString()));
                // Return result
                return new ClaimsIdentity(claims);
            }
        }

    }

}
