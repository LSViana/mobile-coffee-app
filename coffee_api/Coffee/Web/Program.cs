using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Web.ArgumentHandlers;

namespace Web
{
    public class Program
    {
        private static Dictionary<string, Func<string[], int, IWebHost, Task<int>>> arguments;

        public static async Task Main(string[] args)
        {
            InitializeArgumentDictionary();
            var webHost = CreateWebHostBuilder(args).Build();
            await HandleArguments(args, webHost);
            webHost.Run();
        }

        private static void InitializeArgumentDictionary()
        {
            SeederHandler seederHandler = new SeederHandler();
            arguments = new Dictionary<string, Func<string[], int, IWebHost, Task<int>>> {
                { seederHandler.SeedCommand, seederHandler.Handle },
            };
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();

        private static async Task HandleArguments(string[] args, IWebHost webHost)
        {
            for (int i = 0; i < args.Length; i++)
            {
                var arg = args[i];
                if(arguments.ContainsKey(arg))
                {
                    // Offset is used to "consume" next arguments from the current one
                    var offset = await arguments[arg]?.Invoke(args, i, webHost);
                    i += offset;
                }
            }
        }
    }
}
