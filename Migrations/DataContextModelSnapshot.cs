﻿// <auto-generated />
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using myblazor.Data;

#nullable disable

namespace myblazor.Migrations
{
    [DbContext(typeof(DataContext))]
    partial class DataContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.1")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("myblazor.Models.PortfolioProject", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<string>("Description")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Title")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("WebUrl")
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("Id");

                    b.ToTable("PortfolioProjects");

                    b.HasData(
                        new
                        {
                            Id = 1,
                            Description = "Alot of fun",
                            Title = "First project",
                            WebUrl = "google.dk"
                        },
                        new
                        {
                            Id = 2,
                            Description = "Alot of fun",
                            Title = "Second project",
                            WebUrl = "google.dk"
                        },
                        new
                        {
                            Id = 3,
                            Description = "Alot of fun",
                            Title = "Third project",
                            WebUrl = "google.dk"
                        });
                });
#pragma warning restore 612, 618
        }
    }
}
