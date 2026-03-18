import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'misskey_client',
  tagline: 'A pure Dart Misskey API client library',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'https://librarylibrarian.github.io',
  baseUrl: '/misskey_client/',

  organizationName: 'LibraryLibrarian',
  projectName: 'misskey_client',

  onBrokenLinks: 'throw',

  markdown: {
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },

  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'ja'],
    localeConfigs: {
      en: {label: 'English'},
      ja: {label: '日本語'},
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
          editUrl:
            'https://github.com/LibraryLibrarian/misskey_client/tree/main/docs/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'misskey_client',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          type: 'localeDropdown',
          position: 'right',
        },
        {
          href: 'https://github.com/LibraryLibrarian/misskey_client',
          label: 'GitHub',
          position: 'right',
        },
        {
          href: 'https://pub.dev/packages/misskey_client',
          label: 'pub.dev',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Getting Started',
              to: '/',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/LibraryLibrarian/misskey_client',
            },
            {
              label: 'pub.dev',
              href: 'https://pub.dev/packages/misskey_client',
            },
          ],
        },
      ],
      copyright: `Copyright \u00a9 ${new Date().getFullYear()} LibraryLibrarian. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['dart', 'yaml', 'bash'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
