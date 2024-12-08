using myshared.Models;
using System.Text.Json.Serialization;

namespace myshared.DTOs
{
	public class ExampleDTO
	{
		public string Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public ExampleDTO() { }

		// manual mapping, not needed with mapster
		/*public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);*/
	}
}