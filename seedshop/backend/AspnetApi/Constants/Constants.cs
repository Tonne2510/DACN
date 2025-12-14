namespace AspnetApi.Constants
{
    public class Constants
    {
        public const string ROOT_IMAGE = "wwwroot/images";

        public static readonly Dictionary<string, string> REQUEST_APPROVAL = new Dictionary<string, string>
    {
        { "PENDING", "PENDING" },
        { "APPROVE", "APPROVED" },
        { "REJECT", "REJECTED" }
    };
    }
}
