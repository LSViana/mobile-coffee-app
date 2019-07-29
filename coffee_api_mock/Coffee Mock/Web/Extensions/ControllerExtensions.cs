using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Web.Data;
using Web.Domain;

namespace Web.Extensions
{
    public static class ControllerExtensions
    {
        public static async Task<User> GetUserAuthenticated(this ControllerBase @this, Db db)
        {
            var hasUser = @this.User.HasClaim(x => x.Type == nameof(User.Id));
            if(hasUser)
            {
                var claimId = @this.User.Claims.First(x => x.Type == nameof(User.Id));
                var userId = Guid.Parse(claimId.Value);
                var user = await db.Users.FirstAsync(x => x.Id == userId);
                return user;
            }
            return null;
        }
    }
}
