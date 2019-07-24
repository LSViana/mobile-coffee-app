using Infrastructure.Seeder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.ArgumentHandlers
{
    public class SeederHandler : ArgumentHandler
    {
        public override string SeedCommand => "seed";
        private bool seedHandled;

        public override async Task<int> Handle(string[] args, int i, IWebHost data)
        {
            if (seedHandled)
            {
                return 0;
            }
            seedHandled = true;
            //
            var currentArg = args[i];
            if (currentArg.Equals("seed", StringComparison.CurrentCultureIgnoreCase))
            {
                var scope = data.Services.CreateScope();
                var seeder = scope.ServiceProvider.GetRequiredService<CoffeeSeeder>();
                await seeder.Seed();
            }
            return 0;
        }
    }
}
