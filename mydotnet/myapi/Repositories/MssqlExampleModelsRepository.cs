using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Repositories
{
	public class MssqlExampleModelsRepository : IMssqlExampleModelsRepository
	{
		private readonly DataContext _context;

		public MssqlExampleModelsRepository(DataContext context)
		{
			_context = context;
		}

		public async Task AddAsync(ExampleDTO exampleDTO)
		{
			// service
			var example = new MssqlExampleModel(exampleDTO);

			// repo
			_context.Add(example);
			await _context.SaveChangesAsync();
		}

		public async Task DeleteAsync(int id)
		{
			// service
			var example = await _context.ExampleModels.FindAsync(id);
			if(example != null)
			{
				// repo
				_context.ExampleModels.Remove(example);
				await _context.SaveChangesAsync();
			}
		}

		public async Task<List<MssqlExampleModel>> GetAllAsync()
		{
			var examples = await _context.ExampleModels.ToListAsync();

			//List<ExampleDTO> exampleDTOS = new List<ExampleDTO>();
			//foreach (var example in examples)
			//{
			//	exampleDTOS.Add(new ExampleDTO(example));
			//}

			//return exampleDTOS;
			return examples;
		}

		public async Task<MssqlExampleModel> GetByIdAsync(int id)
		{
			var example = await _context.ExampleModels.FindAsync(id);
			//var exampleDto = new ExampleDTO(example);
			//return exampleDto;
			return example;
		}

		public async Task UpdateAsync(ExampleDTO exampleDTO, int id)
		{
			// service
			var dbModel = await _context.ExampleModels.FindAsync(id);
			var updatedDbModel = new MssqlExampleModel(exampleDTO);
			if (dbModel != null)
			{
				// repo
				dbModel.Title = updatedDbModel.Title;
				dbModel.Description = updatedDbModel.Description;
				//dbProject.WebUrl = projectDTO.WebUrl;

				await _context.SaveChangesAsync();
			}
		}
	}
}
