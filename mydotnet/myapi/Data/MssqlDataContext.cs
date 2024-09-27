using Microsoft.EntityFrameworkCore;
using myshared.Models;

namespace myapi.Data
{
    public class MssqlDataContext : DbContext
    {
        public MssqlDataContext(DbContextOptions<MssqlDataContext> options) : base (options)
        {
        }

		public DbSet<MssqlExampleModel> ExampleModels => Set<MssqlExampleModel>();
		//public DbSet<MssqlExampleModel> ExampleModels { get; set; }
		//public DbSet<PortfolioProject> PortfolioProjects { get; set; }

		protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<MssqlExampleModel>().HasData(
                new MssqlExampleModel { Id = 1, Title = "First project", Description = "Alot of fun", WebUrl = "google.dk" },
                new MssqlExampleModel { Id = 2, Title = "Second project", Description = "Alot of fun", WebUrl = "google.dk" },
                new MssqlExampleModel { Id = 3, Title = "Third project", Description = "Alot of fun", WebUrl = "google.dk" }
            );

            //modelBuilder.Entity<PortfolioProject>();
            //modelBuilder.Entity<PortfolioProject>().ToTable("PortfolioProjects");
        }
    }
}
