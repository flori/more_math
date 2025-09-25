module MoreMath
  # Contains constant values used in mathematical function implementations.
  #
  # These constants are essential for high-precision numerical computations,
  # particularly in the Lanczos approximation for gamma functions and error
  # function approximations. The constants are carefully chosen to balance
  # accuracy and computational efficiency.
  module Constants
    # Module containing mathematical constants used in function implementations
    module FunctionsConstants
      # Lanczos coefficients for gamma function approximation
      #
      # These coefficients are part of the Lanczos approximation formula,
      # which provides a highly accurate method for computing the logarithm
      # of the gamma function. The Lanczos method is particularly effective
      # for maintaining numerical stability across a wide range of inputs.
      #
      # @note These values are precomputed for optimal accuracy in the
      #   Lanczos approximation algorithm
      LANCZOS_COEFFICIENTS = [
        0.99999999999999709182,
        57.156235665862923517,
        -59.597960355475491248,
        14.136097974741747174,
        -0.49191381609762019978,
        0.33994649984811888699e-4,
        0.46523628927048575665e-4,
        -0.98374475304879564677e-4,
        0.15808870322491248884e-3,
        -0.21026444172410488319e-3,
        0.21743961811521264320e-3,
        -0.16431810653676389022e-3,
        0.84418223983852743293e-4,
        -0.26190838401581408670e-4,
        0.36899182659531622704e-5,
      ]

      # Precomputed value of half the natural logarithm of 2π
      #
      # This constant is used in Stirling's approximation and various
      # statistical calculations. It's computed as:
      #   0.5 * Math.log(2 * Math::PI)
      #
      # @note This value appears in the Lanczos approximation formula
      #   and other mathematical identities involving the gamma function
      HALF_LOG_2_PI = 0.5 * Math.log(2 * Math::PI)

      # Parameter for error function approximation
      #
      # This constant is used in the rational approximation of the error
      # function. It's derived from the relationship:
      #   ERF_A = -8 * (Math::PI - 3) / (3 * Math::PI * (Math::PI - 4))
      #
      # The value helps optimize the accuracy of the erf approximation
      # for a wide range of input values
      ERF_A = -8 * (Math::PI - 3) / (3 * Math::PI * (Math::PI - 4))

      # Square root of 2
      #
      # This constant is frequently used in statistics and probability,
      # particularly in the normal distribution and error function
      # calculations.
      ROOT2 = Math.sqrt(2)
    end
  end
end
