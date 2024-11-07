using Microsoft.EntityFrameworkCore;
using MongoDB.Bson;
using myapi.Data;
using myshared.DTOs;
using myshared.Models;

namespace myapi.Services
{
	public class ExampleService
	{
		private MssqlDataContext _dbcontext;
        private DbSet<ExampleModel> _exampleModelRepository;
		private ILogger<ExampleService> _log;

        public ExampleService(
			ILogger<ExampleService> log,
			MssqlDataContext dbcontext
		)
		{
			_dbcontext = dbcontext;
			_exampleModelRepository = dbcontext.ExampleModels;
			_log = log;
        }

		public async Task<List<ExampleDTO>> GetAllAsync()
		{
			var exampleModels = new List<ExampleModel>();

            try
            {
                exampleModels = await _exampleModelRepository.ToListAsync();
            }
			catch (Exception ex)
			{
                _log.LogError("### EXCEPTION WAS CAUGHT IN EXAMPLESERVICE GETALLASYNC WITH MESSAGE: " + ex + " ###");
            }


            if (exampleModels == new List<ExampleModel>()) return new List<ExampleDTO>();
			if (exampleModels is null) return null;

			var exampleDTOs = exampleModels.Select(x => new ExampleDTO(x)).ToList();
			return exampleDTOs;
		}

		public async Task<ExampleDTO?> GetByIdAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.Include(x => x.ExampleNavigationProperty).Where(x => x.Id == id).FirstOrDefaultAsync();
			
			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO> AddAsync(ExampleDTO exampleDTO)
		{
			var exampleModel = new ExampleModel(exampleDTO);

			if (exampleModel != null)
			{
				exampleModel.Id = ObjectId.GenerateNewId().ToString();
				await _exampleModelRepository.AddAsync(exampleModel);
				await _dbcontext.SaveChangesAsync();

				exampleModel = await _exampleModelRepository.Where(x => x.Id == exampleModel.Id).FirstOrDefaultAsync();
			}

			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> UpdateAsync(string id, ExampleDTO updatedExampleDTO)
		{
			var exampleModel = await _exampleModelRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			if (exampleModel != null)
			{
				exampleModel.Title = updatedExampleDTO.Title;
				exampleModel.Description = updatedExampleDTO.Description;

				await _dbcontext.SaveChangesAsync();

				exampleModel = await _exampleModelRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			}

			if (exampleModel == new ExampleModel()) return new ExampleDTO();
			if (exampleModel is null) return null;

			return new ExampleDTO(exampleModel);
		}

		public async Task<ExampleDTO?> DeleteAsync(string id)
		{
			var exampleModel = await _exampleModelRepository.Where(x => x.Id == id).FirstOrDefaultAsync();
			if (exampleModel != null)
			{
				_exampleModelRepository.Remove(exampleModel);
				await _dbcontext.SaveChangesAsync();
			}

			if (exampleModel is null) return new ExampleDTO();

			return new ExampleDTO(exampleModel);
		}
	}
}
