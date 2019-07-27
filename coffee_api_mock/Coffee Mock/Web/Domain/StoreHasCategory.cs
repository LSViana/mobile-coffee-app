using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Web.Domain
{
    public class StoreHasCategory
    {
        public Guid StoreId { get; set; }
        public Guid CategoryId { get; set; }
        public virtual Store Store { get; set; }
        public virtual Category Category { get; set; }
    }
}
