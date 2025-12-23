using Monolith.Logic.DTOs;
using Monolith.Query.Aggregates;

namespace Monolith.Query.Repositories
{
	public interface IExampleModelRepository
	{
		Task<List<ExampleAggregate>?> GetAllAsync();
		Task<ExampleAggregate?> GetByIdAsync(string id);
		Task<ExampleAggregate?> AddAsync(ExampleDTO exampleDTO);
		Task<ExampleAggregate?> UpdateAsync(string id, ExampleDTO updatedExampleDTO);
		Task<ExampleAggregate?> DeleteAsync(string id);
	}
}
