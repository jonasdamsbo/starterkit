using Monolith.Logic.DTOs;
using Monolith.Data.Models;

namespace Monolith.Query.Repositories
{
	public interface IExampleModelRepository
	{
		Task<List<ExampleModel>?> GetAllAsync();
		Task<ExampleModel?> GetByIdAsync(string id);
		Task<ExampleModel?> AddAsync(ExampleModel exampleDTO);
		Task<ExampleModel?> UpdateAsync(string id, ExampleModel updatedExampleDTO);
		Task<ExampleModel?> DeleteAsync(string id);
	}
}
