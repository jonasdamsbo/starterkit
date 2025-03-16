using myshared.Models;
using System.Linq;
using System.Text.Json.Serialization;

namespace myshared.DTOs
{
	public class ExampleDTO
	{
		public string? Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public List<ExampleNavigationPropertyDTO>? ExampleNavigationPropertiesDTO { get; set; }


		public ExampleDTO() { }
		public ExampleDTO(ExampleModel example) =>
		(Id, Title, Description, ExampleNavigationPropertiesDTO) = (example.Id, example.Title, example.Description,
			example.ExampleNavigationProperties.Select(x => new ExampleNavigationPropertyDTO(x)).ToList()
		);
	}
	//public enum DtoTypes
	//{
	//	ExampleDTO,
	//	ExampleNavigationPropertyDTO
	//}
}