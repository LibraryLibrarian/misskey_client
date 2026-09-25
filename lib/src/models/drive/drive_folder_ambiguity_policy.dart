/// Determines how to resolve same-named Drive folders.
///
/// Misskey allows same-named sibling folders, and `folders/find` has no
/// ordering guarantee, so this does not provide a "first" option. [oldest]
/// and [newest] compare folders by `createdAt` and then by `id`.
enum DriveFolderAmbiguityPolicy { error, oldest, newest }
