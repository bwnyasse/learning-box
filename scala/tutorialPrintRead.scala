import scala.io.StdIn._
object ScalaTutorial {

  def main(args: Array[String]){

    var numberGuess = 0

    val name = "Derek"
    val age = 39
    val weight = 175.5

    do {
      print("Read number : ")
      numberGuess = readLine.toInt;
    } while(numberGuess != 15)

    printf("U guess the number %d\n ", 15)

    println(s"Hello $name")
    println(f"Are u really ${age + 1 } and $weight%.2f")
  }
}