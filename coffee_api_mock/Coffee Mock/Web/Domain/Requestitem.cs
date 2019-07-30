using System;
namespace Web.Domain
{
    public class RequestItem
    {
        public Guid Id { get; set; }
        public Guid RequestId { get; set; }
        public Guid ProductId { get; set; }
        public int Amount { get; set; }
        public decimal Price { get; set; }
        public Product Product { get; set; }
        public Request Request { get; set; }
    }
}
