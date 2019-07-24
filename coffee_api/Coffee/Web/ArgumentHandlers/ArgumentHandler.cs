using Microsoft.AspNetCore.Hosting;
using System.Threading.Tasks;

namespace Web.ArgumentHandlers
{
    public abstract class ArgumentHandler
    {
        public abstract string SeedCommand { get; }
        public abstract Task<int> Handle(string[] args, int i, IWebHost data);
    }
}
