using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.Domain
{
    public class ProductInStore
    {
        public Guid ProductId { get; set; }
        public Guid StoreId { get; set; }
        public virtual Product Product { get; set; }
        public virtual Store Store { get; set; }
    }
}
