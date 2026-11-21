using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BlazorServerApp.Models;

[Table("Klant")]
public class Klant
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Naam is verplicht.")]
    [StringLength(150, ErrorMessage = "Naam mag maximaal 150 tekens zijn.")]
    public string Naam { get; set; } = string.Empty;

    [Required(ErrorMessage = "Adres is verplicht.")]
    [StringLength(200, ErrorMessage = "Adres mag maximaal 200 tekens zijn.")]
    public string Adres { get; set; } = string.Empty;

    [Required(ErrorMessage = "Postcode is verplicht.")]
    [StringLength(20, ErrorMessage = "Postcode mag maximaal 20 tekens zijn.")]
    public string Postcode { get; set; } = string.Empty;

    [Required(ErrorMessage = "Woonplaats is verplicht.")]
    [StringLength(120, ErrorMessage = "Woonplaats mag maximaal 120 tekens zijn.")]
    public string Woonplaats { get; set; } = string.Empty;
}
