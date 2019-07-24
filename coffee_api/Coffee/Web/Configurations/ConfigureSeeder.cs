using Infrastructure.ConfigurationModels;
using Infrastructure.Seeder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.Configurations
{
    public static class ConfigureSeeder
    {
        public static void AddSeeder(this IServiceCollection services, IHostingEnvironment environment, IConfiguration configuration)
        {
            if(environment.IsDevelopment())
            {
                var seederData = new SeederConfigurationData();
                configuration.Bind("Seeder", seederData);
                services.AddSingleton(typeof(SeederConfigurationData), seederData);
                services.AddTransient<CoffeeSeeder>();
            }
        }
    }
}
