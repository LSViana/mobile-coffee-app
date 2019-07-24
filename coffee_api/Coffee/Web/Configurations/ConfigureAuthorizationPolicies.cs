using Infrastructure.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace Web.Configurations
{
    public static class ConfigureAuthorizationPolicies
    {
        private static AuthorizationOptions options;

        public static void AddAuthorizationPolicies(this IServiceCollection services)
        {
            services.AddAuthorization(options =>
            {
                new AuthorizationPolicies().ConfigureAuthorizationPolicies(options);
            });
        }

        
    }
}
