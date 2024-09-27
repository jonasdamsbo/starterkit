using Microsoft.EntityFrameworkCore;
using myshared.Models;

namespace myapi.Data
{
    public class MssqlDataContext : DbContext
    {
        public MssqlDataContext(DbContextOptions<MssqlDataContext> options) : base (options)
        {
        }

		public DbSet<ExampleModel> ExampleModels => Set<ExampleModel>();

		protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<ExampleModel>().HasData(
                new ExampleModel { Id = "1", Title = "First project", Description = "Alot of fun", WebUrl = "google.dk" },
                new ExampleModel { Id = "2", Title = "Second project", Description = "Alot of fun", WebUrl = "google.dk" },
                new ExampleModel { Id = "3", Title = "Third project", Description = "Alot of fun", WebUrl = "google.dk" }
            );

            //modelBuilder.Entity<ExampleModel>();
            //modelBuilder.Entity<ExampleModel>().ToTable("ExampleModels");
        }
    }
}
