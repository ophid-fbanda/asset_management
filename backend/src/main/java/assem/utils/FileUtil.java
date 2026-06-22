package assem.utils;

import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public final class FileUtil {

    private static final List<String> ALLOWED_EXTENSIONS =
            Arrays.asList(".pdf", ".jpeg", ".png", ".jpg", ".csv", ".xlsx");

    private FileUtil() {}

    public static FileUtil instance() {
        return new FileUtil();
    }

    // Stores one upload under "storage" with a unique name and returns that
    // name, or null when the file is missing/disallowed/unwritable. Callers with
    // several attachments simply call save per file.
    public String save(MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) {
                return null;
            }

            String originalFilename = file.getOriginalFilename();
            String extension = null;
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            }

            if (extension == null || !ALLOWED_EXTENSIONS.contains(extension)) {
                return null;
            }

            String newFilename = System.currentTimeMillis() + "_" + new Random().nextInt(100000) + extension;
            Path storagePath = Paths.get("storage").resolve(newFilename);
            Files.createDirectories(storagePath.getParent());
            file.transferTo(storagePath.toAbsolutePath());

            return newFilename;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
