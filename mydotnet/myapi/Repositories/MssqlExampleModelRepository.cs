using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Repositories
{
	public class MssqlExampleModelRepository : IMssqlExampleModelRepository
	{
		private readonly MssqlDataContext _context;

		public MssqlExampleModelRepository(MssqlDataContext context)
		{
			_context = context;
		}

		public async Task<MssqlExampleModel> AddAsync(MssqlExampleModel newModel)
		{
			// service
			//var example = new MssqlExampleModel(exampleDTO);

			// repo
			try
			{
				_context.Add(newModel);
				await _context.SaveChangesAsync();
				var example = await GetByIdAsync(newModel.Id);
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<MssqlExampleModel> DeleteAsync(int id)
		{
			// service
			

			try
			{
				var example = await _context.ExampleModels.FindAsync(id);
				if (example != null)
				{
					// repo
					_context.ExampleModels.Remove(example);
					await _context.SaveChangesAsync();
				}
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}

		public async Task<List<MssqlExampleModel>> GetAllAsync()
		{
			try
			{
				var examples = await _context.ExampleModels.ToListAsync();
				return examples;
			}
			catch (Exception ex)
			{
				return new List<MssqlExampleModel>();
				//throw;
			}

			

			//List<ExampleDTO> exampleDTOS = new List<ExampleDTO>();
			//foreach (var example in examples)
			//{
			//	exampleDTOS.Add(new ExampleDTO(example));
			//}

			//return exampleDTOS;
		}

		public async Task<MssqlExampleModel> GetByIdAsync(int id)
		{
			try
			{

				var example = await _context.ExampleModels.FindAsync(id);
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
			//var exampleDto = new ExampleDTO(example);
			//return exampleDto;
		}

		public async Task<MssqlExampleModel> UpdateAsync(int id, MssqlExampleModel updatedExample)
		{
			try
			{
				// service
				var example = await GetByIdAsync(id);
				//var updatedDbModel = new MssqlExampleModel(updatedExample);
				if (example != null)
				{
					// repo
					example.Title = updatedExample.Title;
					example.Description = updatedExample.Description;
					//dbProject.WebUrl = projectDTO.WebUrl;

					await _context.SaveChangesAsync();
					example = await GetByIdAsync(id);
				}
				return example;
			}
			catch (Exception ex)
			{
				return null;
				//throw;
			}
		}
	}
}
