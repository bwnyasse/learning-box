import scala.io.StdIn._
object ScalaTutorial {

  def main(args: Array[String]){

    var numberGuess = 0

    do {
      print("Read number : ")
      numberGuess = readLine.toInt;
    }while(numberGuess != 15)

    printf("U guess the number %d\n ", 15)
  }
}