


using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace AspnetApi.Utils
{
    public class CustomConverter : JsonConverter<DateTime?>
    {
        private readonly string _format;


        public CustomConverter()
        {
            _format = "dd/MM/yyyy"; 
        }

       
        public CustomConverter(string format)
        {
            _format = format;
        }

        public override DateTime? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.String)
            {
                var stringValue = reader.GetString();
                if (string.IsNullOrWhiteSpace(stringValue))
                {
                    return null;
                }

                // Attempt to parse the string using the specified format
                if (DateTime.TryParseExact(stringValue, _format, CultureInfo.InvariantCulture, DateTimeStyles.None, out var dateValue))
                {
                    return dateValue;
                }
            }
            else if (reader.TokenType == JsonTokenType.Null)
            {
                return null;
            }

            throw new JsonException($"Invalid date format. Expected format: {_format}");
        }

        public override void Write(Utf8JsonWriter writer, DateTime? value, JsonSerializerOptions options)
        {
            if (value.HasValue)
            {
                writer.WriteStringValue(value.Value.ToString(_format));
            }
            else
            {
                writer.WriteNullValue();
            }
        }
    }
}
