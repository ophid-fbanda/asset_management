package assem.service;

import assem.exchange.auth.StaffProfileRequest;
import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.AuthRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthRepository authRepository;

    public Result<?> login(StaffProfileRequest dto) {
        Result<ProfileExchange> profileResult = authRepository.profileByCredentials(dto);
        if (!profileResult.isOk()) {
            return Result.error(profileResult.getMessage());
        }
        if (profileResult.getData() == null) {
            return Result.error("Invalid email or password.");
        }

        return Result.ok(profileResult.getData());
    }

}
