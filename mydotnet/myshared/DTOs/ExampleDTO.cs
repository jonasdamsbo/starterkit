using myshared.Models;

namespace myshared.DTOs
{
	public class ExampleDTO
	{
		public int Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public ExampleDTO() { }
		public ExampleDTO(MssqlExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);
		public ExampleDTO(NosqlExampleModel example) =>
		(Id, Title, Description) = (example.Id, example.Title, example.Description);
	}
}
