using System;
namespace Web.Domain
{
    public class UserHasStore
    {
        public Guid UserId { get; set; }
        public Guid StoreId { get; set; }
        public virtual User User { get; set; }
        public virtual Store Store { get; set; }
    }
}
