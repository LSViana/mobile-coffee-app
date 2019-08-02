using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
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

        public static async Task NotifyUser(this ControllerBase @this, Db db, IConfiguration configuration, Guid userId, string title, string body)
        {
            var user = await db.Users.FirstOrDefaultAsync(x => x.Id == userId);
            if (user is null || user.FcmToken is null)
            {
                return;
            }
            var httpClient = new HttpClient();
            var request = new HttpRequestMessage(HttpMethod.Post, "https://fcm.googleapis.com/fcm/send");
            request.Content = new StringContent(JsonConvert.SerializeObject(new
            {
                notification = new
                {
                    title,
                    body,
                },
                data = new
                {
                    click_action = "FLUTTER_NOTIFICATION_CLICK",
                    status = 1,
                },
                to = user.FcmToken
            }), Encoding.UTF8, "application/json");
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("key", "=" + configuration["FirebaseCloudMessaging:Key"]);
            var response = await httpClient.SendAsync(request);
        }
    }
}
