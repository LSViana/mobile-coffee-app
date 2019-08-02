using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Web.Data;
using Web.Extensions;
using Web.Transfer.User;

namespace Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        private readonly Db db;

        public AuthenticationController(Db db)
        {
            this.db = db;
        }

        [HttpPost("authenticate/jwt")]
        public async Task<IActionResult> Authenticate([FromBody] Login login)
        {
            var user = await db.Users.FirstOrDefaultAsync(x => x.Email == login.Email && x.Password == login.Password);
            if (user != null)
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                // Token configurations
                var tokenLifetime = TimeSpan.FromDays(7);
                var now = DateTime.Now;
                var jwtToken = tokenHandler.CreateJwtSecurityToken(new SecurityTokenDescriptor()
                {
                    Audience = "Audience",
                    Issuer = "Issuer",
                    Expires = now + tokenLifetime,
                    IssuedAt = now,
                    NotBefore = now,
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                        new Claim(nameof(Domain.User.Id), user.Id.ToString()),
                    }),
                    SigningCredentials =
                        new SigningCredentials(
                            new SymmetricSecurityKey(new HMACSHA256(Encoding.UTF8.GetBytes("secret-key")).ComputeHash(Encoding.UTF8.GetBytes("token-key"))),
                            SecurityAlgorithms.HmacSha256
                        ),
                });
                // Updating user FCM token
                user.FcmToken = login.FcmToken;
                db.Users.Update(user);
                await db.SaveChangesAsync();
                // Returning result
                return Ok(new
                {
                    user.Id,
                    user.Name,
                    user.Email,
                    user.DeliveryAddress,
                    user.FcmToken,
                    Token = tokenHandler.WriteToken(jwtToken),
                });
            }
            else
            {
                return NotFound();
            }
        }

        [HttpPost("removefcmtoken")]
        [Authorize]
        public async Task<IActionResult> RemoveFcmToken()
        {
            var user = await this.GetUserAuthenticated(db);
            if(user is null)
            {
                return NotFound();
            }
            user.FcmToken = null;
            db.Users.Update(user);
            await db.SaveChangesAsync();
            return Ok();
        }
    }
}
