class OcfCollabJwtAuthenticator
  ISSUER = "https://ocf-collab.org"

  attr_reader :token

  def initialize(token:)
    @token = token
  end

  def token_data
    @token_data ||= JWT.decode(
      token,
      nil,
      true,
      {
        jwks: jwks,
        iss: ISSUER,
        algorithm: "RS256",
        verify_expiration: true,
        verify_iss: true,
      },
    )[0]
  end

  private

  def jwks
    @jwks ||= JSON.parse(jwks_response).deep_symbolize_keys
  end

  def jwks_response
    @jwks_keys_response ||= Faraday.get(ENV["JWKS_URL"]).body
  end

  def header
    @header ||= JWT.decode(token, nil, false)[1]
  end
end
