using System;
using System.Collections.Generic;

namespace Web.Domain
{
    public class Request
    {
        public Guid Id { get; set; }
        public Guid StoreId { get; set; }
        public Guid UserId { get; set; }
        public string DeliveryAddress { get; set; }
        public DateTime? DeliveryDate { get; set; }
        public DateTime CreatedAt { get; set; }
        public RequestStatus Status { get; set; }
        public virtual ICollection<RequestItem> Items { get; set; }
        public virtual Store Store { get; set; }
        public virtual User User { get; set; }
    }
}
