Name:           xfce4-stopwatch-plugin
Version:        0.6.0
Release:        1%{?dist}
Summary:        Stopwatch plugin for the Xfce panel

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/panel-plugins/xfce4-stopwatch-plugin/0.6/xfce4-stopwatch-plugin-%{version}.tar.xz

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfce4-panel-devel >= 4.20.0
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Xfce4-stopwatch-plugin is a stopwatch plugin for the Xfce panel.

%prep
%autosetup

%build
xdt-autogen
%configure
%make_build

%install
%make_install

%find_lang xfce4-stopwatch-plugin

%files -f xfce4-stopwatch-plugin.lang
%license COPYING
%{_libdir}/xfce4/panel/plugins/libstopwatch*
%{_datadir}/xfce4/panel/plugins/stopwatch.desktop
%{_datadir}/icons/hicolor/*/apps/xfce4-stopwatch-plugin*

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 0.6.0-1
- Initial release for Xfce 4.20 compatibility
