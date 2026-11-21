using BlazorServerApp.Models;
using Microsoft.EntityFrameworkCore;

namespace BlazorServerApp.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
    public DbSet<Klant> Klanten => Set<Klant>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Klant>(entity =>
        {
            entity.ToTable("Klant");
            entity.HasKey(k => k.Id);
            entity.Property(k => k.Naam).IsRequired().HasMaxLength(150);
            entity.Property(k => k.Adres).IsRequired().HasMaxLength(200);
            entity.Property(k => k.Postcode).IsRequired().HasMaxLength(20);
            entity.Property(k => k.Woonplaats).IsRequired().HasMaxLength(120);
        });
    }
}
