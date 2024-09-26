using myshared.DTOs;

namespace myshared.Models
{
    public class MssqlExampleModel
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }

		public MssqlExampleModel() { }
		public MssqlExampleModel(ExampleDTO exampleDTO) =>
		(Id, Title, Description) = (exampleDTO.Id, exampleDTO.Title, exampleDTO.Description);
	}
}