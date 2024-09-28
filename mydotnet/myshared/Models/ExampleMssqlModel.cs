using myshared.DTOs;

namespace myshared.Models
{
    public class ExampleMssqlModel
	{
		public string Id { get; set; }
		public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public ExampleMssqlModel() { }
		public ExampleMssqlModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description);
	}
}