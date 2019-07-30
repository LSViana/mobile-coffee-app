using System;
using System.Collections.Generic;

namespace Web.Transfer.Request
{
    public class CreateRequest
    {
        public Guid StoreId { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public string DeliveryAddress { get; set; }
        public ICollection<CreateRequestItem> Items { get; set; }

        public class CreateRequestItem
        {
            public Guid ProductId { get; set; }
            public int Amount { get; set; }
        }
    }
}
