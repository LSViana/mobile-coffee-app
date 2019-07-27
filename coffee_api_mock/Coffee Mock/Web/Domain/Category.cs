using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.Domain
{
    public class Category
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public virtual ICollection<StoreHasCategory> Stores { get; set; }
        public virtual ICollection<Product> Products { get; set; }
    }
}
