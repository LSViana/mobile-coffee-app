using Infrastructure.Security;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace Web.Configurations
{
    public static class ConfigureAuthorizationPolicies
    {
        public static void AddAuthorizationPolicies(this IServiceCollection services)
        {
            services.AddAuthorization(options =>
            {
                new AuthorizationPolicies().ConfigureAuthorizationPolicies(options);
            });
        }
    }
}
