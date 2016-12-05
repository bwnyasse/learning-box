import scala.math._

object ScalaTutorial {

  def main(args: Array[String]) {

    // def funcName (param1:dataType, param2: dataType) : returnType  = {
    //      function body
    //      return valueToReturn
    // }

    def getSum(num1: Int = 1, num2: Int = 1): Int = {
      // Return not really need, scala output value based on the evalution of the last line of code
      num1 + num2
    }

    println("5 + 4 =  " + getSum(num1 = 5, num2 = 4))
    def sayHi() {
      println("Say Hi tutorial")
    }
    sayHi

    def factorial(num: BigInt): BigInt = {
      if (num <= 1 )
        1
      else
        num * factorial(num - 1)
    }
    println("Factorial of 4 = " + factorial(4))


  }
}